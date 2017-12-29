#!/bin/bash
# Need to cd into the root director where the proto files are stored, otherwise protoc complains
VERSION="v1alpha1"
OUT_DIR="../MacAssistant/Generated/"
cd googleapis
protoc \
	google/assistant/embedded/$VERSION/embedded_assistant.proto \
	google/rpc/status.proto \
	--swiftgrpc_out=$OUT_DIR \
	--swift_out=$OUT_DIR \
	--swift_opt=Visibility=Public \
	--plugin=../grpc-swift/Plugin/protoc-gen-swiftgrpc \
	--plugin=../grpc-swift/Plugin/protoc-gen-swift