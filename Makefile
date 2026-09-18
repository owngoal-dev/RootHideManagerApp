ifneq ($(filter-out format format-check check,$(if $(MAKECMDGOALS),$(MAKECMDGOALS),all)),)

ARCHS = arm64 arm64e
TARGET = iphone:latest:15.0
DEB_ARCH = iphoneos-arm64e
IPHONEOS_DEPLOYMENT_TARGET = 15.0

INSTALL_TARGET_PROCESSES = Veil

THEOS_PACKAGE_SCHEME = roothide

FINALPACKAGE ?= 1
DEBUG ?= 0

include $(THEOS)/makefiles/common.mk

XCODE_SCHEME = RootHide

XCODEPROJ_NAME = RootHide

RootHide_XCODEFLAGS = MARKETING_VERSION=$(THEOS_PACKAGE_BASE_VERSION) \
	IPHONEOS_DEPLOYMENT_TARGET="$(IPHONEOS_DEPLOYMENT_TARGET)" \
	CODE_SIGN_IDENTITY="" \
	AD_HOC_CODE_SIGNING_ALLOWED=YES
RootHide_XCODE_SCHEME = $(XCODE_SCHEME)
RootHide_CODESIGN_FLAGS = -Sentitlements.plist
RootHide_INSTALL_PATH = /Applications

include $(THEOS_MAKE_PATH)/xcodeproj.mk

before-all::
	echo "#define VARCLEANRULESHASH" $$(cksum -o 3 RootHide/VarCleanRules.json | awk '{print $$1}') > RootHide/VarCleanRules.h

clean::
	rm -rf ./packages/*

before-package::
	ldid -M -S./nickchan.entitlements $(THEOS_STAGING_DIR)/Applications/Veil.app/Veil

after-install::
	install.exec 'uiopen -b wiki.qaq.veil'

endif

SWIFT_FORMAT ?= xcrun swift-format
CLANG_FORMAT ?= clang-format
SWIFT_SOURCES := $(wildcard RootHide/*.swift Tests/*.swift)
CLANG_SOURCES := $(filter-out RootHide/NSJSONSerialization+Comments.h RootHide/NSJSONSerialization+Comments.m,$(wildcard RootHide/*.[mh] RootHide/AppDataCleaner/*.[mh] Tests/*.m))

.PHONY: format format-check check
format:
	$(SWIFT_FORMAT) format --in-place $(SWIFT_SOURCES)
	$(CLANG_FORMAT) -i $(CLANG_SOURCES)

format-check:
	$(SWIFT_FORMAT) lint --strict $(SWIFT_SOURCES)
	$(CLANG_FORMAT) --dry-run --Werror $(CLANG_SOURCES)

check:
	python3 Tests/check_localizations.py
	python3 Tests/check_environment_summary.py
	python3 Tests/check_service_ports.py
	./Tests/check.sh
