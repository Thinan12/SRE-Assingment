provider "null" {}

# Simulate cluster setup (local k3s)
resource "null_resource" "k3s_cluster" {
  provisioner "local-exec" {
    command = "echo 'Using existing k3s cluster'"
  }
}

# Install Argo CD (simulation)
resource "null_resource" "argocd_install" {
  depends_on = [null_resource.k3s_cluster]

  provisioner "local-exec" {
    command = <<EOT
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
EOT
  }
}
