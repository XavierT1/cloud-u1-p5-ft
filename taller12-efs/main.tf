# Configuracion del proveedor de AWS
provider "aws" {
  region = var.region
}

# creamos el security group[cite: 8]
resource "aws_security_group" "mi-sg-efs" {
  name        = "mi-security-group-terraform"
  description = "Security group para mi instancia de Terraform"
  vpc_id      = "vpc-0c2502819cb5330b9" # ID de tu VPC en AWS

  # regla de entrada para SSH[cite: 8]
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Declaracion de la instancia EC2 conectada al mismo Security Group
resource "aws_instance" "mi_instancia_efs" {
  ami                    = "var.ami_id"
  instance_type          = "var.tipo_instancia"
  key_name               = "mi-primera-llaves-ft"
  security_groups        = [aws_security_group.mi-sg-efs.name]
  tags = {
    Name = "MiInstanciTerraform2"
  }
  vpc_security_group_ids = [aws_security_group.mi-sg-efs.id]
   count = var.cantidad_instancias
}