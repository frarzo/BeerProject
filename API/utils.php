<?php

class Encryption {

    private string $method = 'AES-256-CBC';
    private string $key;
    private string $iv;

    public function __construct() {
        $basicKey = 'fh934fhdwofj340rjf390hf390h43232';
        $iv = 'hf934fhewfudsifs';

        $this->key = substr(hash('sha256', $basicKey), 0, 32);
        $this->iv = substr(hash('sha256', $iv), 0, 32);
    }

    public function encrypt($toEncrypt) {
        return openssl_encrypt($toEncrypt, $this->method, $this->key, 0, $this->iv);
    }
    public function decrypt($toDecrypt) {
        return openssl_decrypt($toDecrypt, $this->method, $this->key, 0, $this->iv);
    }
}
