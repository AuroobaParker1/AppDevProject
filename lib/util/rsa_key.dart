
import 'dart:math';

import 'package:pointycastle/export.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:asn1lib/asn1lib.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

import '../API/fix_secure.dart';
class RsaKeyHelper {
   AsymmetricKeyPair<PublicKey, PrivateKey> generateECKeyPair() {
  final ecDomainParameters = ECDomainParameters('prime256v1');
  final secureRandom = FortunaRandom();

  final keyParams = ECKeyGeneratorParameters(ecDomainParameters);
  final keyGenerator = ECKeyGenerator();

  keyGenerator.init(ParametersWithRandom(keyParams, secureRandom));

  return keyGenerator.generateKeyPair();
}
}

    String encrypt(String plaintext, AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair) {
       
        final encrypter = Encrypter(RSA(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey));
        return encrypter.encrypt(plaintext).base64;
    }

    String decrypt(String cipherBase64, AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair) {
        final encrypter = Encrypter(RSA(publicKey: keyPair.publicKey, privateKey: keyPair.privateKey));
        return encrypter.decrypt64(cipherBase64);
    }

    RSAPublicKey parsePublicKeyFromPem(String pemString) {
    List<int> publicKeyDER = decodePEM(pemString);
    var asn1Parser = ASN1Parser(Uint8List.fromList(publicKeyDER));
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    var publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;

    var publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes());
    var publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    var modulus = publicKeySeq.elements[0] as ASN1Integer;
    var exponent = publicKeySeq.elements[1] as ASN1Integer;

    return RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
  }

    parsePrivateKeyFromPem(pemString) {
        List<int> privateKeyDER = decodePEM(pemString);
        var asn1Parser = new ASN1Parser(Uint8List.fromList(privateKeyDER));
        var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        var version = topLevelSeq.elements[0];
        var algorithm = topLevelSeq.elements[1];
        var privateKey = topLevelSeq.elements[2];

        asn1Parser = new ASN1Parser(privateKey.contentBytes());
        var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

        version = pkSeq.elements[0];
        var modulus = pkSeq.elements[1] as ASN1Integer;
        var publicExponent = pkSeq.elements[2] as ASN1Integer;
        var privateExponent = pkSeq.elements[3] as ASN1Integer;
        var p = pkSeq.elements[4] as ASN1Integer;
        var q = pkSeq.elements[5] as ASN1Integer;
        var exp1 = pkSeq.elements[6] as ASN1Integer;
        var exp2 = pkSeq.elements[7] as ASN1Integer;
        var co = pkSeq.elements[8] as ASN1Integer;

        RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
                modulus.valueAsBigInteger,
                privateExponent.valueAsBigInteger,
                p.valueAsBigInteger,
                q.valueAsBigInteger
        );

        return rsaPrivateKey;
    }

    encodePublicKeyToPem(RSAPublicKey publicKey) {
        var algorithmSeq = new ASN1Sequence();
        var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
        var paramsAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
        algorithmSeq.add(algorithmAsn1Obj);
        algorithmSeq.add(paramsAsn1Obj);

        var publicKeySeq = new ASN1Sequence();
        publicKeySeq.add(ASN1Integer(publicKey.modulus!));
        publicKeySeq.add(ASN1Integer(publicKey.exponent!));
        var publicKeySeqBitString = new ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

        var topLevelSeq = new ASN1Sequence();
        topLevelSeq.add(algorithmSeq);
        topLevelSeq.add(publicKeySeqBitString);
        var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

        return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
    }

    encodePrivateKeyToPem(RSAPrivateKey privateKey) {

        var version = ASN1Integer(BigInt.from(0));

        var algorithmSeq = new ASN1Sequence();
        var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
        var paramsAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
        algorithmSeq.add(algorithmAsn1Obj);
        algorithmSeq.add(paramsAsn1Obj);

        var privateKeySeq = new ASN1Sequence();
        var modulus = ASN1Integer(privateKey.n!);
        var publicExponent = ASN1Integer(BigInt.parse('65537'));
        var privateExponent = ASN1Integer(privateKey.d!);
        var p = ASN1Integer(privateKey.p!);
        var q = ASN1Integer(privateKey.q!);
        var dP = privateKey.d! % (privateKey.p! - BigInt.from(1));
        var exp1 = ASN1Integer(dP);
        var dQ = privateKey.d! % (privateKey.q! - BigInt.from(1));
        var exp2 = ASN1Integer(dQ);
        var iQ = privateKey.q!.modInverse(privateKey.p!);
        var co = ASN1Integer(iQ);

        privateKeySeq.add(version);
        privateKeySeq.add(modulus);
        privateKeySeq.add(publicExponent);
        privateKeySeq.add(privateExponent);
        privateKeySeq.add(p);
        privateKeySeq.add(q);
        privateKeySeq.add(exp1);
        privateKeySeq.add(exp2);
        privateKeySeq.add(co);
        var publicKeySeqOctetString = new ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

        var topLevelSeq = new ASN1Sequence();
        topLevelSeq.add(version);
        topLevelSeq.add(algorithmSeq);
        topLevelSeq.add(publicKeySeqOctetString);
        var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

        return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
    }
    
List<int> decodePEM(String pem) {
    var startsWith = [
        "-----BEGIN PUBLIC KEY-----",
        "-----BEGIN PRIVATE KEY-----",
        "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
        "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    ];
    var endsWith = [
        "-----END PUBLIC KEY-----",
        "-----END PRIVATE KEY-----",
        "-----END PGP PUBLIC KEY BLOCK-----",
        "-----END PGP PRIVATE KEY BLOCK-----",
    ];
    bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

    for (var s in startsWith) {
        if (pem.startsWith(s)) {
            pem = pem.substring(s.length);
        }
    }

    for (var s in endsWith) {
        if (pem.endsWith(s)) {
            pem = pem.substring(0, pem.length - s.length);
        }
    }

    if (isOpenPgp) {
        var index = pem.indexOf('\r\n');
        pem = pem.substring(0, index);
    }

    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    return base64.decode(pem);
}