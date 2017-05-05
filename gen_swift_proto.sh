protoc \
	google/assistant/embedded/v1alpha1/embedded_assistant.proto \
	google/rpc/status.proto \
	--swiftgrpc_out=/Users/vanshgandhi/Desktop \
	--swift_out=/Users/vanshgandhi/Desktop \
	--swift_opt=Visibility=Public \
	--plugin=./protoc-gen-swiftgrpc \
	--plugin=./protoc-gen-swift