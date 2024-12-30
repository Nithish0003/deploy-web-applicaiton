package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
    t.Parallel()

    // Define the Terraform options
    terraformOptions := &terraform.Options{
        // The path to where your Terraform code is located
        TerraformDir: "../terraform",

        // Variables to pass to our Terraform code using -var options
        Vars: map[string]interface{}{
            "notification_email": "your-email@example.com",
            "db_pass":            "your_db_password",
            "access_key_id":      "your_access_key_id",
            "secret_key_id":      "your_secret_access_key",
        },

        // Disable colors in Terraform commands so its easier to parse stdout/stderr
        NoColor: true,
    }

    // Clean up resources with "terraform destroy" at the end of the test
    defer terraform.Destroy(t, terraformOptions)

    // Run "terraform init" and "terraform apply". Fail the test if there are any errors.
    terraform.InitAndApply(t, terraformOptions)

    // Run `terraform output` to get the values of output variables
    vpcID := terraform.Output(t, terraformOptions, "vpc_id")
    SubnetIDs := terraform.OutputList(t, terraformOptions, "subnet_ids")
    dbInstanceEndpoint := terraform.Output(t, terraformOptions, "db_instance_endpoint")
    elbDNSName := terraform.Output(t, terraformOptions, "elb_dns_name")

    // Verify the VPC ID is not empty
    assert.NotEmpty(t, vpcID)

    // Verify the public subnet IDs are not empty
    assert.NotEmpty(t, SubnetIDs)

    // Verify the DB instance endpoint is not empty
    assert.NotEmpty(t, dbInstanceEndpoint)

    // Verify the ELB DNS name is not empty
    assert.NotEmpty(t, elbDNSName)

    // Verify the ELB is accessible
    elbURL := "http://" + elbDNSName
    maxRetries := 10
    timeBetweenRetries := 10 * time.Second

    http_helper.HttpGetWithRetry(t, elbURL, nil, 200, "Hello, World!", maxRetries, timeBetweenRetries)
}