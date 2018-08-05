#!/bin/bash
# Need to cd into the root director where the proto files are stored, otherwise protoc complains
VERSION="v1alpha2"
OUT_DIR="../MacAssistant/Generated/"

if [ ! -f "grpc-swift/protoc-gen-swiftgrpc" ] || [ ! -f "grpc-swift/protoc-gen-swift" ] ; then
	cd grpc-swift
	make
	cd ..
fi

cd googleapis

if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

protoc \
	google/assistant/embedded/$VERSION/embedded_assistant.proto \
	google/rpc/status.proto \
	google/type/latlng.proto \
	--swiftgrpc_out=Client=true,Server=false:$OUT_DIR \
	--swift_out=$OUT_DIR \
	--plugin=../grpc-swift/protoc-gen-swift \
	--plugin=../grpc-swift/protoc-gen-swiftgrpc \
	--swift_opt=Visibility=Public
