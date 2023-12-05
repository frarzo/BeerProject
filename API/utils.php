<?php

class Encryption {

    const method = 'AES-256-CBC';
    private string $key;
    private string $iv;

    public function __construct() {
        $basicKey = 'progettoesameinternetofthings123';
        $iv = 'stringarandom123';

        $this->key = substr(hash('sha256', $basicKey), 0, 32);
        $this->iv = substr(hash('sha256', $iv), 0, 32);
    }

    public function encrypt($toEncrypt) {
        return openssl_encrypt($toEncrypt, method, $this->key, 0, $this->iv);
    }
    public function decrypt($toDecrypt) {
        return openssl_decrypt($toDecrypt, method, $this->key, 0, $this->iv);
    }
}
