resource "aws_iam_policy" "rails_policy" {
  name   = "RailsS3Policy"
  policy = file("~/gitlab-cicd/terraform/modules/iam/s3_policy.json")
}

resource "aws_iam_role" "rails_role" {
  name               = "RailsIAMRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "rails_role_policy_attachment" {
  name       = "Rails Policy Attachement"
  policy_arn = aws_iam_policy.rails_policy.arn
  roles      = [aws_iam_role.rails_role.name]
}

resource "aws_iam_instance_profile" "rails_profile" {
  name = "RailsInstProfile"
  role = aws_iam_role.rails_role.name
}

