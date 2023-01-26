build:
	@rm -rf docs/*
	hugo --buildFuture

serve:
	hugo serve --buildDrafts --buildFuture

clean:
	@rm -rf $(BUILD_DIR)
