# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

SHELL=/bin/bash

.PHONY: lint
lint:
	@helm lint couchdb

.PHONY: package
package: lint
	@helm package couchdb

.PHONY: publish
publish:
	@git checkout gh-pages
	@git checkout -b gh-pages-update
	@helm repo index docs --url https://apache.github.io/couchdb-helm
	@git add -i
	@git commit
	@echo "To complete the publish step, push the branch to your GitHub remote and create a PR against gh-pages"

# Run end to end tests using KinD
.PHONY: test
test:
	./test/e2e-kind.sh
