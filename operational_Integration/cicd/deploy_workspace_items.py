from os.path import dirname, join
from os import environ
from fabric_cicd import FabricWorkspace, publish_all_items, change_log_level
change_log_level("DEBUG")


def main() -> None:
    workspace_items_folder = join(dirname(dirname(__file__)), "fabric")
    workspace_id = environ["FABRIC_WORKSPACE_ID"]
    target_environment = environ["FABRIC_TARGET_ENV"]

    target_workspace = FabricWorkspace(
        workspace_id=workspace_id,
        environment=target_environment,
        item_type_in_scope=[
            "Notebook",
            "DataPipeline",
            "Environment",
            "SemanticModel",
            "Lakehouse",
            "Warehouse",
        ],
        repository_directory=workspace_items_folder,
    )

    publish_all_items(target_workspace)
    ### unpublish_all_orphan_items(target_workspace)


if __name__ == "__main__":
    main()
