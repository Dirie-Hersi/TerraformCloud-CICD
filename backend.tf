terraform {
    backend "remote" {
        organization = "terraform-dnd"
        
        workspaces {
            name = "TerraformCloud-CICD"
        }
    }
}