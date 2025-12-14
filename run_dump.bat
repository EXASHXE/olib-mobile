@echo off
if not exist api_dump mkdir api_dump
dart lib/api_dump.dart
