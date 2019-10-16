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

.PHONY: test
test:
	@helm lint couchdb

package: test
	@helm package couchdb

.PHONY: package
publish: test
	@git checkout gh-pages
	@helm repo index docs --url https://apache.github.io/couchdb-helm
	@git add -i
	@echo "To complete the publish step, commit and push the chart tgz and updated index to gh-pages"
