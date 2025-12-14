@echo off
dart lib/test_api_structure.dart > test_output.txt 2>&1
type test_output.txt
