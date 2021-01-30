.PHONY: gen-i18n
gen-i18n:
	flutter pub run easy_localization:generate -S resources/langs && \
	flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
