# Configuracion del proveedor de AWS
provider "aws" {
  region = var.region
}

# creamos el security group
resource "aws_security_group" "mi-sg-efs-instancias" {
  name        = "mi-security-group-terraform-efs-intancias"
  description = "Security group para mi instancia de Terraform"
  vpc_id      = "vpc-0c2502819cb5330b9" # ID de tu VPC en AWS

  # regla de entrada para SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # regla de entrada para HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # regla de salida (permite tráfico saliente para paquetes y montaje EFS)
  egress {
    description = "Regla de salida para internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# creamos el security group para EFS
resource "aws_security_group" "mi-sg-efs" {
  name        = "mi-security-group-terraform-efs"
  description = "Security group para mi instancia de Terraform"
  vpc_id      = "vpc-0c2502819cb5330b9" # ID de tu VPC en AWS

  # regla de entrada para SSH
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.mi-sg-efs-instancias.id]
  }

  # regla de entrada para HTTP
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

# Declaracion de la instancia EC2 conectada al mismo Security Group
resource "aws_instance" "mi_instancia_efs" {
  ami                    = "ami-0c230065b91270bc6"
  instance_type          = "t2.micro"
  key_name               = "mi-primera-llaves-ft"
  //security_groups      = [aws_security_group.mi-sg-efs.name]
  count = var.cantidad_instancias
  tags = {
    Name = "Mi instancia EFS-${count.index + 1}"
  }
  vpc_security_group_ids = [aws_security_group.mi-sg-efs-instancias.id]
   
}