resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"
  assume_role_policy = jsondecode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "codebuild.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_codebuild_project" "project" {
  name          = "codebuild-project"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "5"
  artifacts {
    type = "CODEPIPELINE"
  }
    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image        = "aws/codebuild/standard:4.0"
        type         = "LINUX_CONTAINER"
        environment_variable {
            name  = "DB_PASS"
            value = var.db_pass
        }
    }
    source {
        type      = "CODEPIPELINE"
        buildspec = "app/buildspec.yml"
    }
}

resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "codedeploy.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "app" {
  name     = "codedeploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name = aws_codedeploy_app.app.name
  deployment_group_name = "deployment-group"
    service_role_arn = aws_iam_role.codedeploy_role.arn
    deployment_config_name = "CodeDeployDefault.OneAtATime"
    auto_rollback_configuration {
        enabled = true
        events  = ["DEPLOYMENT_FAILURE"]
    }
    deployment_style {
        deployment_option = "WITH_TRAFFIC_CONTROL"
        deployment_type   = "BLUE_GREEN"
    }
    blue_green_deployment_config {
        terminate_blue_instances_on_deployment_success {
            action = "TERMINATE"
            termination_wait_time_in_minutes = 5
        }
        deployment_ready_option {
            action_on_timeout = "CONTINUE_DEPLOYMENT"
        }
        green_fleet_provisioning_option {
            action = "DISCOVER_EXISTING"
        }
    }
    load_balancer_info {
        elb_info {
            name = aws_lb.elb_1.name
        }
    }
    trigger_configuration {
        trigger_events = ["DeploymentFailure"]
        trigger_name   = "trigger"
        trigger_target_arn = aws_codepipeline.pipeline.arn
    }
    ec2_tag_set {
      ec2_tag_filter {
        key = "Name"
        type = "KEY_AND_VALUE"
        value = "instance-[1-2]"
      }
    }
}

resource "aws_codepipeline" "pipeline" {
  name    = "codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
      location = aws_s3_bucket.bucket.bucket
      type     = "S3"
  }

    stage {
        name = "Source"
        action {
            name             = "Source"
            category         = "Source"
            owner            = "ThirdParty"
            provider         = "GitHub"
            version          = "1"
            output_artifacts = ["source_output"]
            configuration = {
                owner             = "Nithish0003"
                repo              = var.github_repo
                branch            = "main"
                oAuthToken        = var.github_token
            }
        }
    }

    stage {
        name = "Build"
        action {
            name             = "Build"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_output"]
            output_artifacts = ["build_output"]
            configuration = {
                ProjectName = aws_codebuild_project.codebuild_project.name
            }
            version = "1"
        }
    }
    stage {
        name = "Deploy"
        action {
            name             = "Deploy"
            category         = "Deploy"
            owner            = "AWS"
            provider         = "CodeDeploy"
            input_artifacts  = ["build_output"]
            configuration = {
                ApplicationName     = aws_codedeploy_app.app.name
                DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
            }
            version = "1"
        }
    }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "codepipeline-bucket"  
}