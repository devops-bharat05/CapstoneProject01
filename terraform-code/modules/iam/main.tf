
// Iam role 
resource "aws_iam_role" "capstone_eks_role" {
  name = "capstone_eks_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name = "capstone-eks-cluster"
  }
}

// attaching policy to the role
resource "aws_iam_role_policy_attachment" "eks-role-policy_attachment" {
  role       = aws_iam_role.capstone_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}