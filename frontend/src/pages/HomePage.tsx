import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { searchDrinks } from '../apis/drinks.api';
import { searchBottles } from '../apis/bottles.api';
import SearchSection from '../components/SearchSection';
import SearchResult from '../components/SearchResult';

const HomePage = () => {
  const [query, setQuery] = useState('');
  const [debouncedQuery, setDebouncedQuery] = useState('');
  const [currentTab, setCurrentTab] = useState('drink');
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const handleQueryChange = (value: string) => {
    setQuery(value);
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => setDebouncedQuery(value), 300);
  };

  const trimmed = debouncedQuery.trim();

  const { data: drinks = [], isFetching: drinksFetching } = useQuery({
    queryKey: ['drinks', trimmed],
    queryFn: () => searchDrinks(trimmed),
    enabled: currentTab === 'drink' && trimmed.length > 0,
  });

  const { data: bottles = [], isFetching: bottlesFetching } = useQuery({
    queryKey: ['bottles', trimmed],
    queryFn: () => searchBottles(trimmed),
    enabled: currentTab === 'bottle' && trimmed.length > 0,
  });

  const loading = currentTab === 'drink' ? drinksFetching : bottlesFetching;

  return (
    <div className="app-container">
      <div className="flex flex-row items-center gap-4">
        <img
          src="/bartender_icon.png"
          alt="Bartender Icon"
          width={60}
          className="hidden md:block"
        />
        <h1 className="m-0">Triple A Bar</h1>
      </div>

      <SearchSection
        query={query}
        onQueryChange={handleQueryChange}
        loading={loading}
        currentTab={currentTab}
        onTabChange={(tab) => { setCurrentTab(tab); setDebouncedQuery(''); setQuery(''); }}
      />

      <SearchResult
        tab={currentTab}
        query={debouncedQuery}
        loading={loading}
        drinks={drinks}
        bottles={bottles}
      />
    </div>
  );
};
export default HomePage;
