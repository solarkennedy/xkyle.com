build:
	hugo

serve:
	hugo serve

deploy: public
	cd public && git add --all && git commit -m "Publishing to gh-pages" && git push origin gh-pages

public:
	rm -rf public
	git worktree add -B gh-pages public origin/gh-pages

BRANCH=gh-pages
BUILD_DIR=public

VERSION=$(shell git describe --dirty)
MESSAGE="Publishing $(VERSION) to gh-pages"

build:
	@rm -rf $(BUILD_DIR)/*
	hugo

publish: setup build
ifneq (,$(findstring dirty,$(VERSION)))
	@echo "Working tree is dirty, please commit before publishing"
else
	@echo "Adding files"
	git -C $(BUILD_DIR) add -f --all
	@echo "Creating commit"
	git -C $(BUILD_DIR) commit -m $(MESSAGE)
	@echo "Pushing new commit"
	git -C $(BUILD_DIR) push origin $(BRANCH)
endif

setup:
	@echo "Cleaning $(BUILD_DIR)"
	@rm -rf $(BUILD_DIR)
	@mkdir $(BUILD_DIR)
	@git worktree prune -v
	@rm -rf .git/worktrees/$(BUILD_DIR)
	@echo "Adding worktree"
	@git worktree add -B $(BRANCH) $(BUILD_DIR) origin/$(BRANCH)
	@git worktree list

clean:
	@rm -rf $(BUILD_DIR)
