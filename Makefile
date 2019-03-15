build:
	@rm -rf docs/*
	hugo

serve:
	hugo serve

clean:
	@rm -rf $(BUILD_DIR)
