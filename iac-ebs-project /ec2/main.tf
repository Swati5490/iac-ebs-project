resource "aws_key_pair" "jenkey123" {
  key_name                    =       var.key_name
  public_key                  =       var.public_key
}


resource "aws_instance" "jenkins_ec2_instance" {
  ami                         =       var.ami_id
  instance_type               =       var.instance_type
  tags                        =       {
            Name              =         var.tag_name
  }
  key_name                    =       var.key_name
  vpc_security_group_ids      =       [var.sg_for_jenkins]
  associate_public_ip_address =       var.enable_public_ip_address
  user_data                   =       var.user_data_install_jenkins
}
resource "aws_ebs_volume" "awsvolume" {
  availability_zone = aws_instance.jenkins_ec2_instance.availability_zone
  size = 20
  encrypted = "false"

  tags = {
    name = "new_volume_mounttoec2"
  }
}
resource "aws_volume_attachment" "mountvolumetoec2" {
  device_name = "/dev/sdd"
  instance_id = aws_instance.jenkins_ec2_instance.id
  volume_id = "${aws_ebs_volume.awsvolume.id}"
}

