data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "kafka_sg" {
  name        = "${var.project_name}-${var.environment}-kafka-sg"
  description = "Allow SSH and Kafka client access"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "Kafka external listener access from my IP"
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "kafka_key" {
  key_name   = "${var.project_name}-${var.environment}-kafka-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "kafka_broker" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.small"
  key_name               = aws_key_pair.kafka_key.key_name
  vpc_security_group_ids = [aws_security_group.kafka_sg.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-kafka-broker"
  }
}

resource "aws_security_group" "producer_sg" {
  name        = "${var.project_name}-${var.environment}-producer-sg"
  description = "Producer instance - SSH access only"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "producer" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.kafka_key.key_name
  vpc_security_group_ids = [aws_security_group.producer_sg.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-producer"
  }
}

# Allow the producer instance to reach the broker's INTERNAL listener
resource "aws_security_group_rule" "kafka_internal_from_producer" {
  type                     = "ingress"
  from_port                = 9095
  to_port                  = 9095
  protocol                 = "tcp"
  security_group_id        = aws_security_group.kafka_sg.id
  source_security_group_id = aws_security_group.producer_sg.id
  description               = "Allow producer instance to reach Kafka INTERNAL listener"
}

