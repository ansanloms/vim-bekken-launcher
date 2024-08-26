import type { Entrypoint } from "./deps/@denops/std/mod.ts";
import { as, assert, is } from "./deps/@core/unknownutil/mod.ts";
import * as yaml from "./deps/@std/yaml/mod.ts";

type ItemCommand = {
  /**
   * 名称。
   */
  name: string;

  /**
   * コマンド。
   */
  command: string;

  /**
   * silent で実行するかどうか。
   */
  silent?: boolean;
};

type Launcher = {
  /**
   * タイトル。
   */
  title: string;

  /**
   * コマンド一覧。
   */
  items: ItemCommand[];
};

const isItemCommand = is.ObjectOf({
  name: is.String,
  command: is.String,
  silent: as.Optional(is.Boolean),
});

const isLauncher = is.ObjectOf({
  title: is.String,
  items: is.ArrayOf(is.UnionOf([isItemCommand])),
});

const getLauncherByPath = async (
  path: string,
): Promise<Launcher> => {
  const launcher = yaml.parse(await Deno.readTextFile(path));
  assert(launcher, isLauncher);

  return launcher;
};

export const main: Entrypoint = (denops) => {
  denops.dispatcher = {
    list: async (paths) => {
      assert(paths, is.ArrayOf(is.String));

      return await Promise.all(
        paths.map(async (path) => ({ ...await getLauncherByPath(path), path })),
      );
    },
  };
};
