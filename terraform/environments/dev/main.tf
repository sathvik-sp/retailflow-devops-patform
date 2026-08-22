module "resource_group" {
  source = "../../modules/resource-group"
  Name   = var.Rd_Name
  Loc    = var.Rg_Loc
}