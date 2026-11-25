# Configuracion del proveedor de AWS
provider "aws" {
  region = var.region
}

# creamos el security group
resource "aws_security_group" "mi-sg-efs-instancias-14" {
  name        = "mi-security-group-terraform-efs-intancias"
  description = "Security group para mi instancia de Terraform"
  vpc_id      = "vpc-0c2502819cb5330b9" # ID de tu VPC en AWS
}
 

# creamos el security group para EFS
resource "aws_security_group" "mi-sg-efs" {
  name        = "mi-security-group-terraform-efs"
  description = "Security group para mi instancia de Terraform"
  vpc_id      = "vpc-0c2502819cb5330b9" # ID de tu VPC en AWS

}

#Reglas SG Instancias

#Reglas de Entrada SG Instancias # Cada regla es un recurso
#Entrada ssh
resource "aws_vpc_security_group_ingress_rule" "entrada_ssh_instancias" {
  security_group_id = aws_security_group.mi-sg-efs-instancias-14.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4  = "0.0.0.0/0"
}

#Salida
#Salida a EFS 2049
resource "aws_vpc_security_group_ingress_rule" "salida_efs" {
  security_group_id = aws_security_group.mi-sg-efs-instancias-14.id
  ip_protocol = "tcp"
  from_port = 2049
  to_port = 2049
  #Destino
  referenced_security_group_id = aws_security_group.mi-sg-efs.id

}

#Salida a Internet all traffic
resource "aws_vpc_security_group_egress_rule" "salida_internet" {
  security_group_id = aws_security_group.mi-sg-efs-instancias-14.id
  ip_protocol = "-1"
  #Destino
  cidr_ipv4 = "0.0.0.0/0"
  
}

#Reglas SG EFS
#Entrada
#Regla entrada EFS 2049
resource "aws_vpc_security_group_ingress_rule" "entrada_efs" {
  security_group_id = aws_security_group.mi-sg-efs-14.id
  ip_protocol = "tcp"
  from_port = 2049
  to_port = 2049
  #Origen
  referenced_security_group_id = aws_security_group.mi-sg-efs-instancias-14.id
  
}

#Salida
#No se require reglas de salida




