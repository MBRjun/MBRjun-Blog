# 为什么我要给 Blog 搓一个 Makefile？
################################################################
nodeversion=$(node -v | grep 19)
nodepm=npm
#nodepm=yarn

.PHONY: world init git modify submodules packages hexo ci generate g clean

world: hexo

init:
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