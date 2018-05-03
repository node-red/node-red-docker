IMAGE := raymondmm/node-red-test
NODE_RED_VERSION := 0.18.4
NODE_VERSION := v8

test:
	true

build-image:
	docker build --file Dockerfile.linux-amd64 --tag $(IMAGE):latest-linux-amd64 .
	docker build --file Dockerfile.linux-arm32v6 --tag $(IMAGE):linux-arm32v6-latest .
	docker build --file Dockerfile.linux-arm32v7 --tag $(IMAGE):linux-arm32v7-latest .
	docker build --file Dockerfile.linux-arm64v8 --tag $(IMAGE):linux-arm64v8-latest .

tag-image:
	docker tag $(IMAGE):latest-linux-amd64 $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64
	docker tag $(IMAGE):linux-arm32v6-latest $(IMAGE):linux-arm32v6-$(NODE_RED_VERSION)
	docker tag $(IMAGE):linux-arm32v7-latest $(IMAGE):linux-arm32v7-$(NODE_RED_VERSION)
	docker tag $(IMAGE):linux-arm64v8-latest $(IMAGE):linux-arm64v8-$(NODE_RED_VERSION)

push-image:
	docker push $(IMAGE):latest-linux-amd64
	docker push $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64
	docker push $(IMAGE):linux-arm32v6-latest
	docker push $(IMAGE):linux-arm32v6-$(NODE_RED_VERSION)
	docker push $(IMAGE):linux-arm32v7-latest
	docker push $(IMAGE):linux-arm32v7-$(NODE_RED_VERSION)
	docker push $(IMAGE):linux-arm64v8-latest
	docker push $(IMAGE):linux-arm64v8-$(NODE_RED_VERSION)

manifest-list-image:
	docker manifest create "$(IMAGE):$(NODE_RED_VERSION)" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64" \
		"$(IMAGE):linux-arm32v6-$(NODE_RED_VERSION)" \
		"$(IMAGE):linux-arm32v7-$(NODE_RED_VERSION)" \
		"$(IMAGE):linux-arm64v8-$(NODE_RED_VERSION)"
	docker manifest annotate "$(IMAGE):$(NODE_RED_VERSION)" "$(IMAGE):linux-arm32v6-$(NODE_RED_VERSION)" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):$(NODE_RED_VERSION)" "$(IMAGE):linux-arm32v7-$(NODE_RED_VERSION)" --os=linux --arch=arm --variant=v7
	docker manifest annotate "$(IMAGE):$(NODE_RED_VERSION)" "$(IMAGE):linux-arm64v8-$(NODE_RED_VERSION)" --os=linux --arch=arm64 --variant=v8
	docker manifest push "$(IMAGE):$(NODE_RED_VERSION)"

	docker manifest create "$(IMAGE):latest" \
		"$(IMAGE):latest-linux-amd64" \
		"$(IMAGE):linux-arm32v6-latest" \
		"$(IMAGE):linux-arm32v7-latest" \
		"$(IMAGE):linux-arm64v8-latest"
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm32v6-latest" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm32v7-latest" --os=linux --arch=arm --variant=v7
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm64v8-latest" --os=linux --arch=arm64 --variant=v8
	docker manifest push "$(IMAGE):latest"

.PHONY: image push-image test
