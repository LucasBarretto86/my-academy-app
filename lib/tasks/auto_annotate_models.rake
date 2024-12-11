# NOTE: only doing this in development as some production environments (Heroku)
# NOTE: are sensitive to local FS writes, and besides -- it's just not proper
# NOTE: to have a dev-mode tool do its thing in production.
if Rails.env.development?
  require 'annotate'

  task :set_annotation_options do
    # You can override any of these by setting an environment variable of the same name.
    Annotate.set_defaults(

      # Basic Configuration for Annotation Positions
      'position_in_class'           => 'bottom',  # Place annotation at the end of the model file
      'position_in_routes'          => 'false',   # Place annotation at the start of the routes file
      'position_in_test'            => 'false',   # Place annotation at the start of test files
      'position_in_fixture'         => 'false',   # Place annotation at the start of fixture files
      'position_in_factory'         => 'false',   # Place annotation at the start of factory files
      'position_in_serializer'      => 'false',   # Place annotation at the end of serializer files

      # Model and Directory Configuration
      'model_dir'                   => 'app/models', # Directory to scan for models
      'root_dir'                    => '',           # Root directory for project
      'ignore_model_sub_dir'        => 'false',      # Ignore subdirectories in models folder

      # File Inclusion and Exclusion Settings
      'models'                      => 'true',       # Annotate models
      'routes'                      => 'false',      # Don't annotate routes file
      'active_admin'                => 'false',      # Exclude ActiveAdmin models
      'exclude_tests'               => 'true',       # Exclude test files from annotation
      'exclude_fixtures'            => 'true',       # Exclude fixture files from annotation
      'exclude_factories'           => 'true',       # Exclude factory files from annotation
      'exclude_serializers'         => 'true',       # Include serializers in annotation
      'exclude_scaffolds'           => 'true',       # Exclude scaffold files from annotation
      'exclude_controllers'         => 'true',       # Exclude controller files from annotation
      'exclude_helpers'             => 'true',       # Exclude helper files from annotation
      'exclude_sti_subclasses'      => 'false',      # Annotate STI subclasses
      'ignore_routes'               => nil,          # Set custom routes to ignore
      'ignore_columns'              => nil,          # List columns to ignore during annotation
      'ignore_unknown_models'       => 'false',      # Fail when unknown models are encountered

      # Foreign Key and Index Settings
      'show_foreign_keys'           => 'true',       # Show foreign key relationships in annotation
      'show_complete_foreign_keys'  => 'false',      # Show complete foreign key details
      'show_indexes'                => 'true',       # Show indexes in annotation
      'simple_indexes'              => 'false',      # Show full index details (not simplified)
      'hide_limit_column_types'     => 'integer,bigint,boolean', # Limit column types to hide
      'hide_default_column_types'   => 'json,jsonb,hstore', # Default column types to hide

      # Formatting and Display Options
      'with_comment'                => 'true',       # Add # comments around annotations
      'format_bare'                 => 'true',       # Plain format for annotations
      'format_rdoc'                 => 'false',      # RDoc format (not used)
      'format_yard'                 => 'false',      # YARD format (not used)
      'format_markdown'             => 'false',      # Markdown format (not used)
      'sort'                        => 'false',      # Keep fields unsorted in annotations
      'classified_sort'             => 'true',       # Sort fields by type and name
      'wrapper_open'                => nil,          # Custom opening wrapper for annotation
      'wrapper_close'               => nil,          # Custom closing wrapper for annotation

      # Performance and Debugging
      'trace'                       => 'false',      # Enable debugging trace
      'force'                       => 'false',      # Force overwrite annotations
      'frozen'                      => 'false',      # Mark files as frozen for tracking changes
      'skip_on_db_migrate'          => 'false',      # Run annotation after database migrations

      # Miscellaneous
      'additional_file_patterns'    => [],           # Additional file patterns to annotate
      'include_version'             => 'false',      # Exclude Rails version from annotation
      'require'                     => ''            # Additional files to require
    )
  end

  Annotate.load_tasks
end
