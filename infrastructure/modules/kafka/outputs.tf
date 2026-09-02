output "kafka_public_ip" {
  value = aws_instance.kafka_broker.public_ip
}

output "producer_public_ip" {
  value = aws_instance.producer.public_ip
}