<?php
// Get the JSON body from the request yeh

$request_body = file_get_contents('php://input');
$data = json_decode($request_body, true);

// Check if the domain is set in the JSON body
if (isset($data['domain'])) {
    try {
        $domain = escapeshellarg($data['domain']);


        // Command to run the shell script with sudo
        $command = "sudo ./remove_domain.sh $domain";

        // Execute the command
        $removeDomainOutput = shell_exec($command);

        // Command to run the shell script with sudo
        $command = "sudo ./create_domain.sh $domain";

        // Execute the command
        $createDomainOutput = shell_exec($command);


        // Check if the command execution was successful
        if ($createDomainOutput === null) {
            throw new Exception('Shell command execution failed');
        }

        $command = "sudo ./setup_ssl.sh $domain";

        // Execute the command
        $setupSSLOutput = shell_exec($command);


        // Check if the command execution was successful
        if ($setupSSLOutput === null) {
            throw new Exception('Shell command execution failed');
        }

        // Return the output
        echo json_encode(['output' => $createDomainOutput . " - " . $setupSSLOutput]);
    } catch (Exception $e) {
        // Return the error message
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    // Return an error if the domain is not set
    echo json_encode(['error' => 'Domain not provided']);
}
?>