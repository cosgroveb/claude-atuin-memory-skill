PLUGIN_NAME := atuin-memory

.PHONY: dist clean install

dist:
	rm -rf dist
	mkdir -p dist/claude-plugin/.claude/skills/$(PLUGIN_NAME)
	mkdir -p dist/claude-plugin/.claude-plugin
	mkdir -p dist/agents/.agents/skills/$(PLUGIN_NAME)
	cp -R skills/$(PLUGIN_NAME)/. dist/claude-plugin/.claude/skills/$(PLUGIN_NAME)/
	cp -R skills/$(PLUGIN_NAME)/. dist/agents/.agents/skills/$(PLUGIN_NAME)/
	cp .claude-plugin/plugin.json dist/claude-plugin/.claude-plugin/plugin.json
	cp .claude-plugin/marketplace.json dist/claude-plugin/.claude-plugin/marketplace.json

clean:
	rm -rf dist

install: dist
	claude plugin marketplace add "$$(pwd)"
	claude plugin install atuin-memory@claude-atuin-memory-skill
