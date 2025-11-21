from os.path import dirname, join
from os import environ
from fabric_cicd import FabricWorkspace, publish_all_items, change_log_level, append_feature_flag
change_log_level("DEBUG")

def main() -> None:
    workspace_items_folder = join(dirname(dirname(__file__)), "fabric")
    workspace_id = environ["FABRIC_WORKSPACE_ID"]
    target_environment = environ["FABRIC_TARGET_ENV"]

    # Enable shortcut publish feature flag
    append_feature_flag("enable_shortcut_publish")

    target_workspace = FabricWorkspace(
        workspace_id=workspace_id,
        environment=target_environment,
        item_type_in_scope=[
            "Notebook",
            "DataPipeline",
            #"Environment", -- Only needs one time deployment
            "SemanticModel",
            "Lakehouse",
            #"Warehouse", -- 29/05/2025: Removing warehouse from the list as it will always be replaced when dbt is run
            "Eventstream",
            "Reflex", 
        ],
        repository_directory=workspace_items_folder,
    )


    
    print("Publishing workspace")
    publish_all_items(target_workspace)
    ### unpublish_all_orphan_items(target_workspace)


if __name__ == "__main__":
    main()
