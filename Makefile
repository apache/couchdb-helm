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

.PHONY: publish
publish: lint
	@mkdir -p new_charts
	@helm package -u -d new_charts couchdb
	@helm repo index --url "https://apache.github.io/couchdb-helm" --merge docs/index.yaml new_charts
	@mv new_charts/couchdb*.tgz docs
	@mv new_charts/index.yaml docs/index.yaml
	@rm -rf new_charts

# Run end to end tests using KinD
.PHONY: test
test:
	./test/e2e-kind.sh
