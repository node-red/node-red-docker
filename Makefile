test:
	true

build-image:
	docker build --file docker_node_$(NODE_VERSION)/Dockerfile.linux-amd64 --tag $(IMAGE):latest-$(NODE_VERSION)-linux-amd64 .
  ifeq ($(NODE_VERSION), v8)
	docker build --file docker_node_$(NODE_VERSION)/Dockerfile.linux-arm32v6 --tag $(IMAGE):latest-$(NODE_VERSION)-linux-arm32v6 .
  endif
	docker build --file docker_node_$(NODE_VERSION)/Dockerfile.linux-arm32v7 --tag $(IMAGE):latest-$(NODE_VERSION)-linux-arm32v7 .
	docker build --file docker_node_$(NODE_VERSION)/Dockerfile.linux-arm64v8 --tag $(IMAGE):latest-$(NODE_VERSION)-linux-arm64v8 .

tag-image:
	docker tag $(IMAGE):latest-$(NODE_VERSION)-linux-amd64 $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64
  ifeq ($(NODE_VERSION), v8)
	docker tag $(IMAGE):latest-$(NODE_VERSION)-linux-arm32v6 $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v6
  endif
	docker tag $(IMAGE):latest-$(NODE_VERSION)-linux-arm32v7 $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v7
	docker tag $(IMAGE):latest-$(NODE_VERSION)-linux-arm64v8 $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm64v8

push-image:
	docker push $(IMAGE):latest-$(NODE_VERSION)-linux-amd64
	docker push $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64
  ifeq ($(NODE_VERSION), v8)
	docker push $(IMAGE):latest-$(NODE_VERSION)-linux-arm32v6
	docker push $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v6
  endif
	docker push $(IMAGE):latest-$(NODE_VERSION)-linux-arm32v7
	docker push $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v7
	docker push $(IMAGE):latest-$(NODE_VERSION)-linux-arm64v8
	docker push $(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm64v8

manifest-list-image:
  ifeq ($(NODE_VERSION), v8)
	docker manifest create "$(IMAGE):$(NODE_RED_VERSION)" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v6" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v7" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm64v8"
	docker manifest annotate "$(IMAGE):$(NODE_RED_VERSION)" "$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v6" --os=linux --arch=arm --variant=v6
  else
	docker manifest create "$(IMAGE):$(NODE_RED_VERSION)" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-amd64" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v7" \
		"$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm64v8"
  endif

	docker manifest annotate "$(IMAGE):$(NODE_RED_VERSION)" "$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm32v7" --os=linux --arch=arm --variant=v7
	docker manifest annotate "$(IMAGE):$(NODE_RED_VERSION)" "$(IMAGE):$(NODE_RED_VERSION)-$(NODE_VERSION)-linux-arm64v8" --os=linux --arch=arm64 --variant=v8
	docker manifest push "$(IMAGE):$(NODE_RED_VERSION)"

  ifeq ($(NODE_VERSION), v8)
	docker manifest create "$(IMAGE):latest" \
		"$(IMAGE):latest-$(NODE_VERSION)-linux-amd64" \
		"$(IMAGE):latest-$(NODE_VERSION)-linux-arm32v6" \
		"$(IMAGE):latest-$(NODE_VERSION)-linux-arm32v7" \
		"$(IMAGE):latest-$(NODE_VERSION)-linux-arm64v8"

	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):latest-$(NODE_VERSION)-linux-arm32v6" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):latest-$(NODE_VERSION)-linux-arm32v7" --os=linux --arch=arm --variant=v7
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):latest-$(NODE_VERSION)-linux-arm64v8" --os=linux --arch=arm64 --variant=v8
	docker manifest push "$(IMAGE):latest"
  endif

.PHONY: image push-image test
