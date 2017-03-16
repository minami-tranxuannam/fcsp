namespace :education do
  desc "create trainings for education"
  task make_trainings: :environment do
    30.times do |n|
      training_params = {
        name: "Training #{n}",
        description: FFaker::Lorem.sentence
      }

      Education::Training.create! training_params
    end
  end
end
