# Module README
# terraform-kubernetes-namespace

## Example Usage
```
module "mynamespace01" {
  source         = "git::https://github.com/mhcurlee/terraform-kubernetes-namespace"
  host           = data.aws_eks_cluster.cluster.endpoint
  cacert         = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token          = data.aws_eks_cluster_auth.cluster.token
  namespace_name = "test01"
  max_pods       = "10"
  cpu_request    = "1000m"
  cpu_limit      = "1000m"
  memory_request = "1G"
  memory_limit   = "1G"
}
```

