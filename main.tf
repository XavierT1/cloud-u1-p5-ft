# Configuracion del proveedor de AWS
provider "aws" {
  region = "us-east-1" # Region donde se desplegaran los recursos
}

# Busca automaticamente la ultima imagen oficial de Amazon Linux 2023 (x86_64)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Declaracion de los recursos de AWS
resource "aws_instance" "mi_instancia" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Mantener en t2.micro compatible
  key_name      = "mi-primera-llaves-ft"

  tags = {
    Name = "MiInstanciaTerraform2"
  }
}
