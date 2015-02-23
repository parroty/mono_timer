FactoryGirl.define do
  factory :timer do
    factory :initial do
      start_time nil
      end_time nil
    end

    factory :running do
      start_time 5.minutes.ago
      end_time nil
    end

    factory :completed do
      start_time 30.minutes.ago
      end_time 5.minutes.ago
    end

    factory :paused do
      start_time 30.minutes.ago

      after(:create) do |timer|
        timer.pauses.create(
          start_time: 20.minutes.ago,
          end_time: nil
        )
      end
    end
  end
end
