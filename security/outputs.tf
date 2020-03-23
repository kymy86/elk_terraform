output "elk_sc_id" {
    value = aws_security_group.elk_sc_default.id
}

output "esearch_sc_id" {
    value = aws_security_group.elk_sc_esearch.id
}

output "elasticsearch_sc_id" {
    value = aws_security_group.elasticsearch.id
}