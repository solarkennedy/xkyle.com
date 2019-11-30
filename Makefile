build:
	@rm -rf docs/*
	hugo

serve:
	hugo serve --buildDrafts --buildFuture

clean:
	@rm -rf $(BUILD_DIR)
