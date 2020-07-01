class apt_update {
    exec { "GoogleSDKKeyring":
        command => 'echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list',
        path => ["/bin", "/usr/bin"],
        creates => '/etc/apt/sources.list.d/google-cloud-sdk.list'
    }

    exec { "GoogleSDKAptKey":
        command => 'curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -',
        path => ["/bin", "/usr/bin"],
    }

    exec { "GoogleSDKInstall":
        command => 'sudo apt-get install google-cloud-sdk',
        path => ["/bin", "/usr/bin"],
        creates => '/usr/bin/gcloud'
    }
}