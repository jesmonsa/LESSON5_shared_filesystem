# It generates Key Pair for WebServer Instnance
resource "tls_private_key" "public_private_key_pair" { # definir el recurso de la clave privada
  algorithm = "RSA" # definir el algoritmo de la clave privada
}
