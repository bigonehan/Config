import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import dotenv from "dotenv";

dotenv.config({ override: true });

const REQUIRED_ENV_KEYS = [
  "GRIST_BASE_URL",
  "GRIST_DOC_ID",
  "GRIST_TABLE",
  "GRIST_API_KEY",
] as const;

const ENV = REQUIRED_ENV_KEYS.reduce<Record<string, string>>((acc, key) => {
  const value = process.env[key];
  if (!value) {
    throw new Error(`Missing required env var ${key} for tests.`);
  }
  acc[key] = value;
  return acc;
}, {});

const originalFetch = globalThis.fetch;

function createColumn(label: string, id: string) {
  return { label, id };
}

function extractRecordId(record: any): number {
  if (!record || typeof record.id === "undefined") {
    throw new Error("Record response does not include id.");
  }
  return Number(record.id);
}

async function waitForRow<T>(
  getter: (rowId: string | number) => Promise<T | null>,
  rowId: string | number,
  attempts = 10,
  delayMs = 250
) {
  for (let i = 0; i < attempts; i += 1) {
    const row = await getter(rowId);
    if (row) return row;
    await new Promise((resolve) => setTimeout(resolve, delayMs));
  }
  throw new Error(`Row ${rowId} not found after waiting.`);
}

function uniqueValue(prefix: string) {
  return `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`;
}

async function ensureProjectValue(getAllRows: () => Promise<Array<{ project?: string }>>) {
  const rows = await getAllRows();
  const value = rows.find((row) => typeof row.project !== "undefined")?.project;
  if (!value) {
    throw new Error("No existing project value found in the table. Seed data first.");
  }
  return value;
}

async function importRelay() {
  return await import("./relay");
}

describe("grist relay helpers", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  afterEach(() => {
    globalThis.fetch = originalFetch;
  });

  it("updateRow maps friendly field names and PATCHes the record", async () => {
    const fetchMock = vi
      .fn()
      // loadTableInfo (columns preloaded)
      .mockResolvedValueOnce({
        ok: true,
        status: 200,
        statusText: "OK",
        json: async () => ({
          id: "Table13",
          columns: [
            createColumn("항목", "Citem"),
            createColumn("설명", "Cdesc"),
            createColumn("상태", "Cstatus"),
            createColumn("완료", "Cdone"),
          ],
        }),
      })
      // PATCH call
      .mockResolvedValueOnce({
        ok: true,
        status: 200,
        statusText: "OK",
        json: async () => ({
          records: [{ id: 42, fields: {} }],
        }),
      });

    globalThis.fetch = fetchMock as unknown as typeof fetch;

    const { initGristConfig, updateRow, __resetGristTestState } = await importRelay();
    __resetGristTestState();
    initGristConfig();

    const result = await updateRow(42, {
      item: "새 항목",
      description: "새 설명",
      status: "진행중",
      done: true,
    });

    expect(fetchMock).toHaveBeenCalledTimes(2);
    const [, patchCall] = fetchMock.mock.calls;
    expect(patchCall[0]).toBe(
      `${ENV.GRIST_BASE_URL}/api/docs/${ENV.GRIST_DOC_ID}/tables/${ENV.GRIST_TABLE}/records`
    );
    expect(patchCall[1].method).toBe("PATCH");
    const payload = JSON.parse(patchCall[1].body);
    expect(payload.records[0]).toEqual({
      id: 42,
      fields: {
        Citem: "새 항목",
        Cdesc: "새 설명",
        Cstatus: "진행중",
        Cdone: true,
      },
    });
    expect(result).toEqual({ id: 42, fields: {} });
  });

  it("insertRow validates required columns and POSTs new record", async () => {
    const fetchMock = vi
      .fn()
      // loadTableInfo (columns cached for map)
      .mockResolvedValueOnce({
        ok: true,
        status: 200,
        statusText: "OK",
        json: async () => ({
          id: "Table13",
          columns: [
            createColumn("프로젝트", "Cproject"),
            createColumn("항목", "Citem"),
            createColumn("설명", "Cdescription"),
            createColumn("상태", "Cstatus"),
            createColumn("완료", "Cdone"),
          ],
        }),
      })
      // POST call
      .mockResolvedValueOnce({
        ok: true,
        status: 200,
        statusText: "OK",
        json: async () => ({
          records: [{ id: 99, fields: { Cproject: "신규" } }],
        }),
      })
      // PATCH call from updateRow enforcement
      .mockResolvedValueOnce({
        ok: true,
        status: 200,
        statusText: "OK",
        json: async () => ({
          records: [{ id: 99 }],
        }),
      });

    globalThis.fetch = fetchMock as unknown as typeof fetch;

    const { initGristConfig, insertRow, __resetGristTestState } = await importRelay();
    __resetGristTestState();
    initGristConfig();

    const result = await insertRow({
      project: "신규 프로젝트",
      item: "할 일",
      description: "세부 설명",
      done: false,
    });

    expect(fetchMock).toHaveBeenCalledTimes(3);
    const [, postCall, patchCall] = fetchMock.mock.calls;
    expect(postCall[0]).toBe(
      `${ENV.GRIST_BASE_URL}/api/docs/${ENV.GRIST_DOC_ID}/tables/${ENV.GRIST_TABLE}/records`
    );
    expect(postCall[1].method).toBe("POST");
    const payload = JSON.parse(postCall[1].body);
    expect(payload.records[0]).toEqual({
      fields: {
        Cproject: "신규 프로젝트",
        Citem: "할 일",
        Cdescription: "세부 설명",
        Cstatus: "R",
        Cdone: false,
      },
    });
    expect(result).toEqual({ id: 99, fields: { Cproject: "신규" } });

    expect(patchCall[1].method).toBe("PATCH");
    const patchPayload = JSON.parse(patchCall[1].body);
    expect(patchPayload.records[0]).toEqual({
      id: 99,
      fields: {
        Cstatus: "R",
      },
    });
  });
});

describe("grist relay helpers (integration)", () => {
  it(
    "insertRow commits to the real table and is readable via getRowById",
    async () => {
      const { initGristConfig, insertRow, getRowById, getAllRows, __resetGristTestState } =
        await importRelay();
      __resetGristTestState();
      initGristConfig();

      const projectValue = await ensureProjectValue(getAllRows);
      const marker = uniqueValue("insert");
      const payload = {
        project: projectValue,
        item: "입력값 테스트",
        description: "입력값설명",
        done: false,
      };

      const created = await insertRow(payload);
      const recordId = extractRecordId(created);

      const fetched = await waitForRow(getRowById, recordId);
      expect(fetched?.project).toBe(payload.project);
      expect(fetched?.item).toBe(payload.item);
      expect(fetched?.description).toBe(payload.description);
      expect(fetched?.status).toBe("R");
      expect(Boolean(fetched?.done)).toBe(payload.done);
    },
    20000
  );

  it(
    "updateRow updates description/status/done on an existing row",
    async () => {
      const { initGristConfig, insertRow, updateRow, getRowById, getAllRows, __resetGristTestState } =
        await importRelay();
      __resetGristTestState();
      initGristConfig();

      const projectValue = await ensureProjectValue(getAllRows);
      const marker = uniqueValue("update");
      const created = await insertRow({
        project: projectValue,
        item: "입력값 테스트",
        description: "입력값설명",
        status: "N/A",
        done: false,
      });
      const recordId = extractRecordId(created);

      const updates = {
        item: "업데이트 완료",
        description: "업데이트 설명 완료",
        status: "C",
        done: true,
      };
      await updateRow(recordId, updates);

      const updated = await waitForRow(getRowById, recordId);
      expect(updated?.item).toBe("업데이트 완료");
      expect(updated?.description).toBe(updates.description);
      expect(updated?.status).toBe(updates.status);
      expect(Boolean(updated?.done)).toBe(updates.done);
    },
    20000
  );
});
