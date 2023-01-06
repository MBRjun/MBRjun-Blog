nodeversion=$(shell node -v | cut -c2-3)
nodepm=npm
#nodepm=yarn

.PHONY: world init git modify submodules packages hexo ci generate g clean

world: hexo

check:
	@if [ -z $(nodeversion) ]; then\
		echo -e "\033[41;37m[CHECK  ]\033[0m Node.js was not detected.\n\033[32m[CHECK  ]\033[0m Install Node.js v18 or v19 first." && exit 2;\
	elif [ $(nodeversion) = "18" ]; then\
		@echo -e "\033[32m[CHECK  ]\033[0m Node.js 18($(shell node -v)) detected";\
	elif [ $(nodeversion) = "19" ]; then\
		echo -e "\033[32m[CHECK  ]\033[0m Node.js 19($(shell node -v)) detected.";\
	else\
		echo -e "\033[41;37m[CHECK  ]\033[0m Unsupported Node.js version detected.\n\033[32m[CHECK  ]\033[0m You are using $(shell node -v) but the program requires v18 or v19.\n\033[32m[CHECK  ]\033[0m Upgrade/Downgrade Node.js to v18/v19, or use nvm to select version." && exit 2;\
	fi

init: check
	@echo -e "\033[32m[GIT    ]\033[0m Updating submodules... " && git submodule update --init --recursive

git: init
	@echo -e "\033[32m[GIT    ]\033[0m \c" && git pull --ff-only

modify: git
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/_config.yml" && cp modify/theme.yml themes/tranquilpeak/_config.yml
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/languages/zh-cn.yml" && cp modify/zh-cn.yml themes/tranquilpeak/languages/zh-cn.yml
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/layout/_partial/footer.ejs" && cp modify/footer.ejs themes/tranquilpeak/layout/_partial/footer.ejs
	@echo -e "\033[32m[MODIFY ]\033[0m themes/tranquilpeak/layout/_partial/post.ejs" && cp modify/post.ejs themes/tranquilpeak/layout/_partial/post.ejs

submodules: packages modify
	@echo -e "\033[32m[PACKAGE]\033[0m submodules: $(nodepm) run grunt -- buildProd" && cd themes/tranquilpeak/ && $(nodepm) run grunt -- buildProd

packages: init
	@echo -e "\033[32m[PACKAGE]\033[0m MBRjun-Blog: $(nodepm) install" && $(nodepm) install
	@echo -e "\033[32m[PACKAGE]\033[0m submodules: $(nodepm) install" && cd themes/tranquilpeak/ && $(nodepm) install

hexo: submodules
	@echo -e "\033[32m[HEXO   ]\033[0m \c"
	hexo generate

ci: hexo

generate: hexo

g: hexo

clean: 
	"\033[32m[CLEAN  ]\033[0m node_modules/" && rm -rf node_modules/
	"\033[32m[CLEAN  ]\033[0m themes/tranquilpeak/" && rm -rf themes/tranquilpeak/
	"\033[32m[CLEAN  ]\033[0m public/" && rm -rf public/