module IronWorkerNG
  module Feature
    module Java
      module MergeJar
        class Feature < IronWorkerNG::Feature::Base
          attr_reader :path

          def initialize(path)
            @path = File.expand_path(path)
          end

          def hash_string
            Digest::MD5.hexdigest(@path + File.mtime(@path).to_i.to_s)
          end

          def bundle(zip)
            zip.add(File.basename(@path), @path)
          end

          def code_for_classpath
            File.basename(@path)
          end
        end

        module InstanceMethods
          def merge_jar(path)
            @features << IronWorkerNG::Feature::Java::MergeJar::Feature.new(path)
          end

          def self.included(base)
            IronWorkerNG::Package::Base.register_feature(:name => 'merge_jar', :for_klass => base, :args => 'PATH')
          end
        end
      end
    end
  end
end