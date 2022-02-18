"auto_auth" = {
  "method" = {
    "config" = {
      "role" = "dex"
    }
    "type" = "kubernetes"
    "mount_path" = "auth/k8s-master"
  }
  "sink" = {
    "config" = {
      "path" = "/vault/agent/.token"
    },
    "type" = "file"
  }
}
"exit_after_auth" = true
"pid_file" = "/vault/agent/.pid"
"template" = {
  "source" = "/vault/templates/config.yaml"
  "destination" = "/vault/secrets/config.yaml"
}
"vault" = {
  "address" = "https://vault.slac.stanford.edu"
}
