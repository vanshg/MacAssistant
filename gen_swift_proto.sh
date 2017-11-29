# Need to cd into the root director where the proto files are stored, otherwise protoc complains
cd googleapis
protoc \
	google/assistant/embedded/v1alpha1/embedded_assistant.proto \
	google/rpc/status.proto \
	--swiftgrpc_out=../MacAssistant \
	--swift_out=../MacAssistant \
	--swift_opt=Visibility=Public \
	--plugin=../grpc-swift/Plugin/protoc-gen-swiftgrpc \
	--plugin=../grpc-swift/Plugin/protoc-gen-swift