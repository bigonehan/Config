/**
 * @generated SignedSource<<58d7c8b08ede90dec6409ee1f03070f9>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type main_AllRowsQuery$variables = Record<PropertyKey, never>;
export type main_AllRowsQuery$data = {
  readonly rows: ReadonlyArray<{
    readonly completedAt: string | null | undefined;
    readonly date: string | null | undefined;
    readonly description: string | null | undefined;
    readonly done: boolean | null | undefined;
    readonly id: string;
    readonly item: string;
    readonly project: string;
    readonly status: string | null | undefined;
  }>;
};
export type main_AllRowsQuery = {
  response: main_AllRowsQuery$data;
  variables: main_AllRowsQuery$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "Row",
    "kind": "LinkedField",
    "name": "rows",
    "plural": true,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "id",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "project",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "item",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "description",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "done",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "status",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "date",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "completedAt",
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "main_AllRowsQuery",
    "selections": (v0/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "main_AllRowsQuery",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "88890d05a3a65a49f7056aa40e248b0d",
    "id": null,
    "metadata": {},
    "name": "main_AllRowsQuery",
    "operationKind": "query",
    "text": "query main_AllRowsQuery {\n  rows {\n    id\n    project\n    item\n    description\n    done\n    status\n    date\n    completedAt\n  }\n}\n"
  }
};
})();

(node as any).hash = "755d7367151acfa59299a1c6ad28740c";

export default node;
