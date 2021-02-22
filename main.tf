terraform {
  required_providers {
    ah = {
      source = "advancedhosting/ah"
      version = "0.1.3"
    }    
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }  
  }
}

provider "ah" {
	access_token = "acces_token"
}
resource "ah_cloud_server" "iscsi" {
   name         	    = "iscsi"
   image        	    = "centos-7-x64"
   datacenter   	    = "ams1"
   product		    = "start-xs"
   create_public_ip_address = false   
   ssh_keys                 = ["f2:64:47:ba:f4:26:5d:a8:da:75:be:b3:34:e8:bf:4a"] 
}
resource "ah_ip" "iscsi" {
  type       = "public"
  datacenter = "ams1"
}
resource "ah_ip_assignment" "iscsi" {
  cloud_server_id = ah_cloud_server.iscsi.id
  ip_address      = ah_ip.iscsi.id
}
resource "ah_private_network" "iscsinet" {
  ip_range = "10.1.0.0/24"
  name = "iscsi_network"
}
resource "ah_volume" "storage" {
  name    = "storage"
  product = "hdd2-ams1"
  file_system = "ext4"
  size    = "1"
}
resource "ah_private_network_connection" "iscsi-connect" {
  cloud_server_id = ah_cloud_server.iscsi.id
  private_network_id = ah_private_network.iscsinet.id
}
resource "ah_volume_attachment" "storage-attach" {
  cloud_server_id = ah_cloud_server.iscsi.id
  volume_id = ah_volume.storage.id
}
provider "ansible"{
}

resource "null_resource" "iscsi" {
provisioner "local-exec" {
    command = "sleep 100; ansible-playbook playbook.yml"
  }
}
