import 'dart:io';

String fixture(String name) =>
    File('test/data/fixtures/$name').readAsStringSync();
