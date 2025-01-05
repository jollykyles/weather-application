data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "weather-app-instance" {
  ami             = "${data.aws_ami.amazon-linux-2.id}"
  instance_type   = "t2.medium"
  key_name        = "${var.keyname}"
  #vpc_id          = "${aws_vpc.development-vpc.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_allow_ssh_jenkins.id}"]
  subnet_id          = "${aws_subnet.public-subnet-1.id}"
  #name            = "${var.name}"
  user_data = "${file("run_app.sh")}"

  associate_public_ip_address = true
  tags = {
    Name = "Weather-App-Instance"
  }
}


resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins traffic for Weather Application"
  vpc_id      = "${aws_vpc.development-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_cluster" "weather-cluster" {
  name     = "weather-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-subnet-1.id,
      aws_subnet.private-subnet-2.id,
      aws_subnet.private-subnet-3.id
    ]
  }

  tags = {
    Name = "weather-cluster"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::329599640731:role/eks-node-role"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_policy_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_eks_node_group" "weather-cluster-node-group" {
  cluster_name    = aws_eks_cluster.weather-cluster.name
  node_group_name = "weather-cluster-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id,
    aws_subnet.private-subnet-3.id
  ]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name = "weather-cluster-node-group"
  }
}

resource "aws_instance" "jenkins-instance" {
  ami             = "${data.aws_ami.amazon-linux-2.id}"
  instance_type   = "t2.medium"
  key_name        = "${var.keyname}"
  #vpc_id          = "${aws_vpc.development-vpc.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_allow_ssh_jenkins.id}"]
  subnet_id          = "${aws_subnet.public-subnet-1.id}"
  #name            = "${var.name}"
  user_data = "${file("install_jenkins.sh")}"

  associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance"
  }
}

output "jenkins_ip_address" {
  value = aws_instance.jenkins-instance.public_dns
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.weather-cluster.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.weather-cluster.name
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.weather-cluster.arn
}
